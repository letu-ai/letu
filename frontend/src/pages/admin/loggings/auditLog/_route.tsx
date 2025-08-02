// import { type RouteObject } from 'react-router-dom';
// import { Navigate } from 'react-router-dom';
// import AuditLogging from './index';
// import AuditLoggingRequest from './request';
// import AuditLoggingRequestDetails from './request/details';
// import AuditLoggingEntity from './entity';
// import AuditLoggingEntityDetails from './entity/details';

// // 使用标准的React Router RouteObject类型，确保使用小写的路径
// const routes: RouteObject[] = [
//   {
//     path: '/admin/loggingsauditlog',
//     element: <AuditLogging />,
//     children: [
//       {
//         path: 'request',
//         element: <AuditLoggingRequest />,
//       },
//       {
//         path: 'request/:id',
//         element: <AuditLoggingRequestDetails />,
//       },
//       {
//         path: 'entity',
//         element: <AuditLoggingEntity />,
//       },
//       {
//         path: 'entity/:id',
//         element: <AuditLoggingEntityDetails />,
//       },
//       {
//         path: '',
//         element: <Navigate to="/admin/loggingsauditlog/request" replace />
//       },
//     ],
//   },
// ];

// export default routes; 