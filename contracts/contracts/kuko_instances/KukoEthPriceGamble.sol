// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../yield/YDaiYieldProvider.sol";
import "../result/BinaryUniswapPrice.sol";
import "../kuko_v1/KukoV1.sol";

contract KukoEthPriceGamble is YDaiYieldProvider, BinaryUniswapPrice, KukoV1 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    ///@notice Hi test
    ///@param name Name of the contract
    constructor(
        string memory name,
        address inputToken,
        address vaultAddress,
        address uniswapPairAddress,
        uint256 fundingPeriod,
        uint256 runningPeriod,
        uint256 weightedFundingPeriod
    )
        public
        YDaiYieldProvider(inputToken, vaultAddress)
        BinaryUniswapPrice(uniswapPairAddress, 1)
        KukoV1("https://uri.com")
    {
        _setName(name);

        _setOwner(msg.sender);
        _setLauncher(msg.sender);

        _setOwnerShare(20000);
        _setLauncherShare(3300);
        _setRunnerShare(3300);
        _setCloserShare(3300);
        _setLoserShare(200000);

        _setFundingPhaseBlockLength(fundingPeriod);
        _setRunningPhaseBlockLength(runningPeriod);
        _setPostFundingPhaseBlockLength(weightedFundingPeriod);

        _setToken(inputToken);

        KukoOptionV1[] memory generatedOptions = _initialize(0);
        options.push(generatedOptions[0]);
        optionIds[generatedOptions[0].id] = 1;
        options.push(generatedOptions[1]);
        optionIds[generatedOptions[1].id] = 2;
    }

    function _onStart() internal override {
        _invest();
    }

    function _onClose() internal override {
        _retrieve();
        finalEarnings = token.balanceOf(address(this));

        options[0].finalized = _resolve(options[0]);
        options[1].finalized = _resolve(options[1]);

        if (options[0].finalized == 1) {
            winnerShares += options[0].shares;
        } else if (options[0].finalized == -1) {
            loserShares += options[0].shares;
        }

        if (options[1].finalized == 1) {
            winnerShares += options[1].shares;
        } else if (options[1].finalized == -1) {
            loserShares += options[1].shares;
        }
    }

    mapping(address => uint256) private deposits;
    uint256 private totalDeposits;
    uint256 private finalEarnings;
    uint256 private winnerShares;
    uint256 private loserShares;

    function deposit(uint256 _option, uint256 _amount) public override isDepositable {
        require(optionIds[_option] != 0, "unknown_option");
        token.safeTransferFrom(msg.sender, address(this), _amount);
        if (running) {
            _invest();
            uint256 progress = block.number - runBlock;
            _mint(msg.sender, _option, _amount - ((_amount * progress) / runningPhaseBlockLength), "");
            options[optionIds[_option]].shares += _amount - ((_amount * progress) / runningPhaseBlockLength);
        } else {
            _mint(msg.sender, _option, _amount, "");
            options[optionIds[_option] - 1].shares += _amount;
        }
        deposits[msg.sender] += _amount;
        totalDeposits += _amount;
    }

    function withdraw(uint256 _option, uint256 amount) public override isClosed {
        require(finalEarnings > totalDeposits, "no_earnings");
        require(optionIds[_option] != 0, "unknown_option");
        require(balanceOf(msg.sender, _option) >= amount, "option_balance_too_low");
        KukoOptionV1 memory option = options[optionIds[_option] - 1];
        require(option.finalized != 0, "option_not_finalized");

        if (option.finalized == 1) {
            uint256 loserBenefits = (finalEarnings - totalDeposits) * (loserShares / (loserShares + winnerShares));
            uint256 loserTax = loserBenefits * (amount / winnerShares) * ((1000000 - loserShare) / 1000000);

            uint256 benefits = (finalEarnings - totalDeposits) * (winnerShares / (loserShares + winnerShares));
            uint256 winnerCut = benefits * (amount / winnerShares);
            token.safeTransfer(msg.sender, winnerCut + loserTax);
        } else if (option.finalized == -1) {
            uint256 benefits = (finalEarnings - totalDeposits) * (loserShares / (loserShares + winnerShares));
            uint256 withdrawAmount = benefits * (amount / loserShares) * (loserShare / 1000000);
            token.safeTransfer(msg.sender, withdrawAmount);
        }
    }

    function withdrawBatch(uint256[] memory options, bool withDeposit) public override {
        for (uint256 idx = 0; idx < options.length; ++idx) {
            uint256 optionBalance = balanceOf(msg.sender, options[idx]);
            withdraw(options[idx], optionBalance);
        }
        if (withDeposit && deposits[msg.sender] > 0) {
            withdrawDeposit(deposits[msg.sender]);
        }
    }

    function withdrawDeposit(uint256 amount) public override isClosed {
        require(amount > 0, "useless_zero_withdraw");
        require(deposits[msg.sender] >= amount, "amount_higher_than_deposit");
        token.safeTransfer(
            msg.sender,
            finalEarnings >= totalDeposits ? amount : (finalEarnings / totalDeposits) * amount
        );
        deposits[msg.sender] -= amount;
    }

    function depositOf(address owner) external view override returns (uint256) {
        return deposits[owner];
    }

    function sharesOf(address owner) external view override returns (uint256) {
        uint256 sharesCount = 0;
        for (uint256 idx = 0; idx < options.length; ++idx) {
            sharesCount += balanceOf(owner, options[idx].id);
        }
        return sharesCount;
    }

    function totalDeposit() external view override returns (uint256) {
        return totalDeposits;
    }

    function totalFunds() external view override returns (uint256) {
        return _totalFunds();
    }

    // How to you list outputs in a generic manner
}
