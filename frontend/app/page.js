"use client";

import EncryptRequesst from '@/components/EncryptRequest'
import FindPublicKey from '@/components/FindPublicKey'
import ConnectWallet from '@/components/ConnectWallet';
import SignAmount from '@/components/SignAmount';

export default function Home() {
  return (
    <>
      <div className='grid grid-cols-3 gap-4 m-4'>
        <ConnectWallet />
      </div>
      <div className='grid grid-cols-3 gap-4 m-4'>
        <SignAmount />
        <EncryptRequesst />
        <FindPublicKey />
      </div>
    </>
  )
}
