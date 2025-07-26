import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import './index.scss';
import { BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { store, persistor } from './store';
import { PersistGate } from 'redux-persist/integration/react';

// 保存原始 console.error
const originalError = window.console.error;
// 覆盖 console.error
window.console.error = (...args) => {
  if (
    args[0] &&
    typeof args[0] === 'string' &&
    (args[0].includes('findDOMNode is deprecated') || args[0].includes('is deprecated in StrictMode'))
  ) {
    return;
  }
  originalError.apply(console, args);
};

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <BrowserRouter>
          <App />
        </BrowserRouter>
      </PersistGate>
    </Provider>
  </StrictMode>,
);
