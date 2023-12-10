"use client";

import EncryptRequesst from '@/components/EncryptRequest'
import ConnectWallet from '@/components/ConnectWallet';
import SignAmount from '@/components/SignAmount';
import { useAccount } from 'wagmi';
import { useEffect, useState } from 'react';
import DecryptRequest from '@/components/DecryptRequest';
import GetEthereumPublicKey from '@/components/GetEthereumPublicKey';
import GetCircomPublicKey from '@/components/GetCircomPublicKey';

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
      <div className='grid grid-cols-3 gap-4 m-4'>
        <ConnectWallet />
      </div>
      {
        address && !loading && (
          <div className='grid grid-cols-3 gap-4 m-4'>
            <SignAmount />
            <EncryptRequesst />
            <DecryptRequest />
            <GetEthereumPublicKey />
            <GetCircomPublicKey />
          </div>
        )
      }
    </>
  )
}
