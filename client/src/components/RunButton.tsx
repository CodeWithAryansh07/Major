"use client";
import { useCodeEditorStore } from "../store/useCodeEditorStore";
import { Play, Square } from "lucide-react";
import { motion } from "framer-motion";

function RunButton() {
    const { runCode, isRunning } = useCodeEditorStore();

    return (
        <motion.button
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={runCode}
            disabled={isRunning}
            className={`
                inline-flex items-center gap-2 px-6 py-2.5 rounded-lg font-medium transition-all duration-200
                ${isRunning 
                    ? 'bg-red-500/20 text-red-400 cursor-not-allowed' 
                    : 'bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:from-blue-600 hover:to-blue-700 shadow-lg hover:shadow-blue-500/25'
                }
            `}
        >
            {isRunning ? (
                <>
                    <Square className="w-4 h-4" />
                    <span>Running...</span>
                </>
            ) : (
                <>
                    <Play className="w-4 h-4" />
                    <span>Run Code</span>
                </>
            )}
        </motion.button>
    );
}

export default RunButton;