export default function Button({ children, onClick }) {
    return (
        <button onClick={onClick} className="btn btn-primary no-animation w-full mt-2">
            {children}
        </button>
    )
}