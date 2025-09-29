const RunningCodeSkeleton = () => {
    return (
        <div className="space-y-3">
            <div className="flex items-center gap-3 text-blue-400">
                <div className="w-5 h-5 border-2 border-blue-400 border-t-transparent rounded-full animate-spin"></div>
                <span className="font-medium">Executing Code...</span>
            </div>
            <div className="space-y-2">
                <div className="h-4 bg-gray-700/50 rounded w-3/4 animate-pulse"></div>
                <div className="h-4 bg-gray-700/50 rounded w-1/2 animate-pulse"></div>
                <div className="h-4 bg-gray-700/50 rounded w-5/6 animate-pulse"></div>
            </div>
        </div>
    );
};

export default RunningCodeSkeleton;