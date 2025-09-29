import { CheckCircle } from "lucide-react";

interface FeatureItemProps {
    children: React.ReactNode;
}

function FeatureItem({ children }: FeatureItemProps) {
    return (
        <div className="flex items-center gap-3">
            <CheckCircle className="w-5 h-5 text-green-400 flex-shrink-0" />
            <span className="text-gray-300">{children}</span>
        </div>
    );
}

export default FeatureItem;