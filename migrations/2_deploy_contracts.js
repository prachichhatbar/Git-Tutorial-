const BCSLA = artifacts.require("./BCSLA.sol")

module.exports = function(deployer) {
    deployer.deploy(BCSLA);
};
