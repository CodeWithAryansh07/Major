interface FeatureCategoryProps {
    label: string;
    children: React.ReactNode;
}

function FeatureCategory({ label, children }: FeatureCategoryProps) {
    return (
        <div className="space-y-4">
            <h3 className="text-lg font-medium text-white">{label}</h3>
            <div className="space-y-2">
                {children}
            </div>
        </div>
    );
}

export default FeatureCategory;