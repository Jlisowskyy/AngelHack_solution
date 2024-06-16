async function connectMetaMask() {
    if (window.ethereum) {
      try {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        console.log('Connected to MetaMask:', accounts[0]);
        return accounts[0];
      } catch (error) {
        console.error('User rejected the request.');
      }
    } else {
      console.error('MetaMask is not installed.');
    }
  }
  
  async function deployContract(abi, bytecode, args) {
    const account = await connectMetaMask();
    if (account) {
      const web3 = new Web3(window.ethereum);
      const contract = new web3.eth.Contract(abi);
      const deploy = contract.deploy({ data: bytecode, arguments: args });
  
      try {
        const newContractInstance = await deploy.send({
          from: account,
          gas: 1500000,
          gasPrice: '30000000000'
        });
        console.log('Contract deployed at address:', newContractInstance.options.address);
        return newContractInstance.options.address;
      } catch (error) {
        console.error('Failed to deploy contract:', error);
      }
    }
  }
  