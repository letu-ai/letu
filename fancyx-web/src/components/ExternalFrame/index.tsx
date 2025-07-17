import { useState } from 'react';
import './index.scss';

const ExternalFrame = ({ url }: { url: string }) => {
  const [loaded, setLoaded] = useState(false);

  return (
    <div className="iframe-container">
      {!loaded && <div className="loading">Loading...</div>}
      <iframe onLoad={() => setLoaded(true)} src={url} />
    </div>
  );
};

export default ExternalFrame;
