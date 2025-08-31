import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/home/test/')({
    component: TestPage
});

function TestPage() {
    return (
        <div>
            <h1>Test Page</h1>
        </div>
    );
}
