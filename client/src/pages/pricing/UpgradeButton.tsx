import toast from "react-hot-toast";

function UpgradeButton() {
    const handleUpgrade = () => {
        toast.success("Upgrade functionality will be implemented with Spring Boot backend!");
    };

    return (
        <button
            onClick={handleUpgrade}
            className="relative group px-8 py-4 bg-gradient-to-r from-blue-500 to-purple-500 text-white 
                     font-medium rounded-xl hover:from-blue-600 hover:to-purple-600 
                     transition-all duration-300 shadow-lg hover:shadow-blue-500/25
                     transform hover:scale-[1.02]"
        >
            <span className="relative z-10">
                Upgrade to Pro
            </span>
            <div className="absolute inset-0 bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl 
                          opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        </button>
    );
}

export default UpgradeButton;