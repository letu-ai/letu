import { StrictMode } from 'react';
import './index.scss';
import ReactDOM from 'react-dom/client'
import { RouterProvider, createRouter } from '@tanstack/react-router'

// Import the generated route tree
import { routeTree } from './routeTree.gen'
import App from './App';

// // 屏蔽Ant Design 组件的findDOMNode警告
// // 保存原始 console.error
// const originalError = window.console.error;
// // 覆盖 console.error
// window.console.error = (...args) => {
//   if (
//     args[0] &&
//     typeof args[0] === 'string' &&
//     (args[0].includes('findDOMNode is deprecated') || args[0].includes('is deprecated in StrictMode'))
//   ) {
//     return;
//   }
//   originalError.apply(console, args);
// };

// Create a new router instance
const router = createRouter({ routeTree })

// Register the router instance for type safety
declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}

// Render the app
const rootElement = document.getElementById('root')!
if (!rootElement.innerHTML) {
  const root = ReactDOM.createRoot(rootElement)
  root.render(
    <StrictMode>
      <App>
        <RouterProvider router={router} />
      </App>
    </StrictMode>,
  )
}