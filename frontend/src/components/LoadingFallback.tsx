import { Spin } from "antd";

const LoadingFallback = () => (
    <div className="flex justify-center items-center h-screen">
        <Spin />
    </div>
);

export default LoadingFallback