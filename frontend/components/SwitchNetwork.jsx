import Button from "./Button";
import { bscTestnet, sepolia } from 'wagmi/chains'
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';

const SwitchNetwork = ({ target }) => {
  const { chain } = useNetwork()
  const { chains, error, isLoading, pendingChainId, switchNetwork } = useSwitchNetwork()
  const isTargetSelected = target ==='bsc' && chain.id === bscTestnet.id || target ==='eth' && chain.id === sepolia.id

  return (
    <div className="flex flex-col items-center justify-center">
      <h3>
        Current Network: {chain.name}
      </h3>
      <Button 
        onClick={() => switchNetwork?.(target === 'bsc' ? bscTestnet.id : sepolia.id)}
        type={!isTargetSelected ? 'primary' : 'disabled'}
      >
        {/* <h3 className="text-black"> */}
        {`Switch to ${target === 'bsc' ? 'BSC Testnet' : 'Sepolia'}`}
        {/* </h3> */}
      </Button>

    </div>
  )
}

export default SwitchNetwork;
