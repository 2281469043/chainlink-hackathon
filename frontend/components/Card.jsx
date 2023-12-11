const Card = ({
    children
}) => {
    return (
        <div className="card card-bordered rounded-lg border-gray-700">
            {children}
        </div>
    );
}

const CardTitle = ({ bgColor, children }) => {
    return (
        <div className={`bg-${bgColor} text-2xl font-bold p-8 rounded-t-lg`}>{ children }</div>
    );
}

const CardBody = ({children}) => {
    return (
        <div className="px-4 py-2">
            {children}
        </div>
    );
}


export {Card, CardTitle, CardBody}