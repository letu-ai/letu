import { createFileRoute } from '@tanstack/react-router';
import DataDictionarySelect from '@/components/DataDictionarySelect';

export const Route = createFileRoute('/home/test/')({
    component: TestPage
});

function TestPage() {
    return (
        <div>
            <h1>Test Page</h1>
            <DataDictionarySelect dictName="position-level" />
        </div>
    );
}
