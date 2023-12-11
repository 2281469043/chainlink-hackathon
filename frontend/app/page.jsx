"use client";

import EncryptRequest from '@/components/EncryptRequest'
import ConnectWallet from '@/components/ConnectWallet';
import SignAmount from '@/components/SignAmount';
import { useAccount } from 'wagmi';
import { useEffect, useState } from 'react';
import DecryptRequest from '@/components/DecryptRequest';
import GetEthereumPublicKey from '@/components/GetEthereumPublicKey';
import GetCircomPublicKey from '@/components/GetCircomPublicKey';
import ProveSupply from '@/components/ProveSupply';
import VerifyProof from '@/components/VerifyProof';
import SendProof from '@/components/SendProof';

export default function Home() {
  const { address } = useAccount();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (loading) {
      setLoading(false);
    }
  }, [loading]);

  return (
    <>
      {
        address && !loading && (
          <div className="grid grid-cols-2">
            <div className="flex flex-col">
              <div className="flex items-center justify-center py-4 bg-red-400">
                <h1 className="text-4xl font-bold">
                  Buyer
                </h1>
              </div>
              <div className="grid grid-cols-2 gap-2 m-2">
                <GetCircomPublicKey />
                <SignAmount />
                <EncryptRequest />
                <VerifyProof />
              </div>
            </div>
            <div className="flex flex-col">
              <div className="flex items-center justify-center py-4 bg-blue-400">
                <h1 className="text-4xl font-bold">
                  Seller
                </h1>
              </div>
              <div className="grid grid-cols-2 gap-2 m-2">
                <GetEthereumPublicKey />
                <DecryptRequest />
                <ProveSupply />
                <SendProof />
              </div>
            </div>
          </div>
        )
      }
      <div className='grid grid-cols-1 gap-4 m-4'>
        <ConnectWallet />
      </div>
    </>
  )
}
