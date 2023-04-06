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
verifyContract('0x1B1D93FaEb9CABfd929fC113D447646f31651493',
    // '0xe7b5B35181eeB87A6f2EE68ef923c4016Cd552fa', '0xca1CdCEc0e9537CC7d586be839655049Cd38301A', '0x8E55E88bf60E0Dc4eF29a9705b584A321EF77B23', ethers.BigNumber.from('10000'), 0
)
