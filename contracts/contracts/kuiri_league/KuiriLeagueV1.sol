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
import "../proxy/Proxy.sol";

struct KukoClass {
    address[] instances;
    bool active;
    bytes constructionData;
}

contract KuiriLeagueV1 is Initializable, ERC20Upgradeable {
    // solhint-disable-next-line
    function __KuiriLeagueV1__init() public {
        __ERC20_init("Kuko", "KUKO");
        _mint(msg.sender, 1000000000000000000000000000);
    }

    modifier onlyMember() {
        require(balanceOf(msg.sender) > 0, "address_has_no_shares");
        _;
    }

    mapping(string => KukoClass) public kukoClasses;

    // protect this with votes
    function setKuko(
        string memory signature,
        address _implementation,
        bytes memory _constructorData,
        bool active
    ) public {
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
        kukoClasses[signature].instances.push(address(cheapInstanceThanksToProxies));
    }
}
