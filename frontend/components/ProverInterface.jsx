"use client";

import TextInput from './TextInput';
import { useState } from 'react';

export default function ProverInterface() {
    const [input, setInput] = useState('');

    return (
        <div>
            <div className="text-2xl font-bold">Prover Interface</div>
            <TextInput label="test" value={input} onChange={setInput} />
        </div>
    );
}