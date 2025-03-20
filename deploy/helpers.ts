import { parseEther } from "ethers"


export const getAddresses = (network: "treasureMainnet" | "treasureTopaz") => {
    if (network === "treasureMainnet") {
        return {
            wrappedNativeToken: "0x263D8f36Bb8d0d9526255E205868C26690b04B88",
            uniswapV2Factory: "0x01e0ed991ff21f4366eedd04a968029bd6f8c61c",
            magicswapRouter: "0xd38F4A9bAeB461B124c1B462653363aafE0B3405"
        }
    } else {
        return {
            wrappedNativeToken: "0x095ded714d42cBD5fb2E84A0FfbFb140E38dC9E1",
            uniswapV2Factory: "0x129a3fe403c94000a89136abdffce7c98fbdab8a",
            magicswapRouter: "0xAd781eD13b5966E7c620B896B6340AbB4dd2ca86"
        }
    }
}
