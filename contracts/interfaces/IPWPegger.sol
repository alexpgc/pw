// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

struct PWConfig { 
    address admin;
    address keeper;
    address pricedon;
    address pwpegdon;
    address correctorup;
    address correctordown;
    address vault;
    uint emergencyth;
    uint volatilityth;
    uint frontrunth;
    uint decimals;
}

interface IPWPegger {
    // admin (permissioned) - EOA or multisig account who is able to chnage configuration of the PW
    function getAdmin() external view returns(address);
    function updAdmin(address) external; // admin only

    // keeper (permissioned) - EOA or multisig oracle account who is able to call sc invocation
    function getKeeper() external view returns(address);
    function updKeeper(address) external; // admin only

    // admin only is able to update DONs used as price and peg data refferences
    function updCurrentDONRef(address) external; // admin only
    function updPathwayDONRef(address) external; // admin only

    // admin only is able to update Corrector SCs refference 
    // increasing gov token price on AMM during pw-intervention call
    function updCorrectorUpProxyRef(address) external; // admin only
    // decreasing gov token price on AMM during pw-intervention call
    function updCorrectorDownProxyRef(address) external; // admin only

    // admin only is able to update vault account associated with pw as funds and LP ops storage
    function updVaultRef(address) external; // admin only

    // admin and keeper oracle are able to pause sc, but only admin can activate it back
    function setPauseOn() external; // keeper and admin
    function setPauseOff() external; // admin only
    function getPauseStatus() external view returns(bool);

    // admin only is able to update threshold parameters in %*BASE_DECIMALS: 0.1% => 100 if BASE_DECIMALS == 10^3
    // emergency threshold used to set pause on if price and peg DONs are far from each other
    function updEmergencyTh(uint) external; // admin only
    // volatility threshold used to succefully do or don't pw intervention
    function updVolatilityTh(uint) external; // admin only
    // volatility threshold used to prevent front run attack during an intervention call
    function updFrontRunProtectionTh(uint) external; // admin only
    // threasholds values must be: E > V > F > 0

    // callIntervention is a main function initializing pw-intervention, called by keeper oracle
    // intervention is comparing keeperCurrentPrice with currentPrice to prevent frontrun
    function callIntervention(uint keeperCurrentPrice) external; // keeper and admin

    function getPWConfig() external view returns (PWConfig memory);
}