import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/account/profile')({
    component: Profile
});


function Profile() {
  

    return (
        <div className="profile-page">
          个人信息编辑，待完善。
        </div>
    );
}

