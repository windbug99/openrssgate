import { AdminSourceDetail } from "@/components/admin/source-detail";

export default async function AdminSourceDetailPage({
  params,
}: {
  params: Promise<{ sourceId: string }>;
}) {
  const { sourceId } = await params;
  return <AdminSourceDetail sourceId={sourceId} />;
}
