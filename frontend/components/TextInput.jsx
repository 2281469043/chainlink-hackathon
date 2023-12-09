export default function TextInput({
    label,
    value,
    onChange,
}) {
    return (
        <label className="form-control w-full">
            <div className="label">
                <span className="label-text">{label}</span>
            </div>
            <input
                type="text" placeholder="Type here"
                className="input input-primary input-bordered w-full"
                value={value}
                onChange={e => onChange(e.target.value)}
            />
        </label>
    );
}