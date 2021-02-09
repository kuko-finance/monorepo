// SPDX-License-Identifier: MIT
//   ___  __    ___  ___  ___  __    ________
//  |\  \|\  \ |\  \|\  \|\  \|\  \ |\   __  \
//  \ \  \/  /|\ \  \\\  \ \  \/  /|\ \  \|\  \
//   \ \   ___  \ \  \\\  \ \   ___  \ \  \\\  \
//    \ \  \\ \  \ \  \\\  \ \  \\ \  \ \  \\\  \
//     \ \__\\ \__\ \_______\ \__\\ \__\ \_______\
//      \|__| \|__|\|_______|\|__| \|__|\|_______|
//
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "../kuko_v1/KukoStatusV1.sol";
import "../kuko_v1/KukoActorsV1.sol";
import "../proxy/Proxy.sol";

struct KukoClass {
    address[] instances;
    bool active;
    bytes constructionData;
}

struct Vote {
    address token;
    mapping(address => bool) voters;
    uint256 votes;
    uint256 threshold;
    uint256 start;
    uint256 end;
}

struct ImplementationUpdateAttempt {
    bool consumed;
    uint256 vote;
    address newImplementation;
}

contract KuiriLeagueV1 is Initializable, ERC20Upgradeable {
    event ImplementationUpdateVote(uint256 attempt);

    uint256 public constant IMPLEMENTATION_VOTE_PERIOD = 45000; // approx 1 week with 13 sec block time

    uint256 public maxSupply;
    mapping(string => KukoClass) public kukoClasses;
    mapping(address => bool) public admins;
    mapping(address => uint256) public fundLock;
    Vote[] public votes;
    ImplementationUpdateAttempt[] public implementationUpdateAttempts;

    // solhint-disable-next-line
    function __KuiriLeagueV1__init() public {
        __ERC20_init("Kuko", "KUKO");
        maxSupply = 1000000000000000000000000000;
        _mint(msg.sender, maxSupply);
        admins[msg.sender] = true;
    }

    // solhint-disable-next-line
    function _upgrade() internal {}

    modifier onlyMember() {
        require(balanceOf(msg.sender) > 0, "address_has_no_shares");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender] == true, "address_not_admin");
        _;
    }

    function updateImplementation(address _newImplementation) public onlyAdmin {
        Vote storage newVote = votes.push();
        newVote.token = address(this);
        newVote.votes = 0;
        newVote.threshold = maxSupply / 2;
        newVote.start = block.number;
        newVote.end = block.number + IMPLEMENTATION_VOTE_PERIOD;
        uint256 newVoteIdx = votes.length - 1;

        implementationUpdateAttempts.push(
            ImplementationUpdateAttempt({consumed: false, vote: newVoteIdx, newImplementation: _newImplementation})
        );
        uint256 implementationUpdateIdx = implementationUpdateAttempts.length - 1;

        emit ImplementationUpdateVote(implementationUpdateIdx);
    }

    function _updateImplementation(address _newImplementation) internal {
        // solhint-disable-next-line
        assembly {
            // solium-disable-line
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, _newImplementation) // this changes the current implementation
        }
        _upgrade();
    }

    function runImplementationUpdate(uint256 _newImplementationIdx) public onlyAdmin {
        require(implementationUpdateAttempts.length > _newImplementationIdx, "invalid_vote_idx");
        ImplementationUpdateAttempt storage attempt = implementationUpdateAttempts[_newImplementationIdx];
        Vote storage _vote = votes[attempt.vote];
        require(block.number >= _vote.end, "vote_period_not_ended");
        require(_vote.votes < _vote.threshold, "vote_prevents_update");
        _updateImplementation(attempt.newImplementation);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(block.number > fundLock[msg.sender], "fund_lock_due_to_vote");
        return ERC20Upgradeable.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        require(block.number > fundLock[sender], "fund_lock_due_to_vote");
        return ERC20Upgradeable.transferFrom(sender, recipient, amount);
    }

    function vote(uint256 _voteIdx) public {
        require(_voteIdx < votes.length, "invalid_vote_id");
        Vote storage _vote = votes[_voteIdx];
        require(block.number < _vote.end, "vote_period_ended");
        require(IERC20Upgradeable(_vote.token).balanceOf(msg.sender) > 0, "cannot_vote_with_no_shares");
        if (_vote.voters[msg.sender] == true) {
            _vote.voters[msg.sender] = false;
            _vote.votes -= IERC20Upgradeable(_vote.token).balanceOf(msg.sender);
        } else {
            _vote.voters[msg.sender] = true;
            _vote.votes += IERC20Upgradeable(_vote.token).balanceOf(msg.sender);
        }
        fundLock[msg.sender] = _vote.end;
    }

    function setKuko(
        string memory signature,
        address _implementation,
        bytes memory _constructorData,
        bool active
    ) public onlyAdmin {
        if (kukoClasses[signature].instances.length > 0) {
            kukoClasses[signature].instances.push(_implementation);
            kukoClasses[signature].constructionData = _constructorData;
            kukoClasses[signature].active = active;
        } else {
            kukoClasses[signature].instances[0] = _implementation;
            kukoClasses[signature].constructionData = _constructorData;
            kukoClasses[signature].active = active;
        }
    }

    function openKukoRound(string memory signature) public {
        require(kukoClasses[signature].active == true, "inactive_kuko");
        KukoStatusV1 lastInstance =
            KukoStatusV1(kukoClasses[signature].instances[kukoClasses[signature].instances.length - 1]);
        require(lastInstance.closed() == true, "last_round_not_closed");

        Proxy cheapInstanceThanksToProxies =
            new Proxy(kukoClasses[signature].constructionData, kukoClasses[signature].instances[0]);
        KukoActorsV1(address(cheapInstanceThanksToProxies)).setLauncher(msg.sender);

        kukoClasses[signature].instances.push(address(cheapInstanceThanksToProxies));
    }
}
