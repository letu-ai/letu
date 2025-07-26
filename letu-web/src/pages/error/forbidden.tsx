import React from "react";
import { Button, Result } from "antd";
import { useNavigate } from "react-router";

const Forbidden: React.FC = () => {
  const navigate = useNavigate();
  return (
    <Result
      status="403"
      title="403"
      subTitle="抱歉，您无权访问此页面。"
      extra={
        <Button type="primary" onClick={() => navigate(-1)}>
          返回上一页
        </Button>
      }
    />
  );
};

export default Forbidden;
