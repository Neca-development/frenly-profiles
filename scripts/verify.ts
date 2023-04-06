import hre from "hardhat";
export async function verifyContract(address: string, ...constructorArguments: any) {
    console.log('Wait a minute for changes to propagate to Etherscan\'s backend...');
    // await waitAMinute();
    console.log('Verifying contract...');
    await hre.run('verify:verify', {
        address,
        constructorArguments: [...constructorArguments],
    });
    console.log('Contract verified on Etherscan ✅');
}


// export function waitAMinute() {
//     return new Promise(resolve => setTimeout(resolve, 60000));
// }
verifyContract('0x9ED4D5251B60a235e5F7Ad08404ccBD7bF918cF9')
