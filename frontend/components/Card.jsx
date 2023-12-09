export default function Card({
    children
}) {
    return (
        <div className="card card-bordered p-8">
            {children}
        </div>
    );
}