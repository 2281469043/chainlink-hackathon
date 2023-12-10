"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';

export default function ProverInterface() {
    const [input, setInput] = useState('');

    return (
        <Card>
            <CardTitle>Prover Interface</CardTitle>
            <TextInput label="test" value={input} onChange={setInput} />
        </Card>
    );
}