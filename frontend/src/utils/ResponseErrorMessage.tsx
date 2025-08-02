import type { IResponseError } from "./httpClient";

interface IErrorMessageProps {
    error: IResponseError;
}

export default function ResponseErrorMessage({error}: IErrorMessageProps){

    if(!error.details)
        return error.message;

    return (
        <div>
            <p>{error.message}</p>
            {typeof error.details === 'string' && <p>{error.details}</p>}
            {typeof error.details === 'object' && error.details.map((detail: string, index: number) => (
                <p key={index}>{detail.replace(':', '：') }</p>
            ))}
        </div>
    )
}