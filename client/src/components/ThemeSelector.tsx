"use client";
import { useCodeEditorStore } from "../store/useCodeEditorStore";
import { THEMES } from "../constants";
import { ChevronDown, Palette } from "lucide-react";
import { useState } from "react";

function ThemeSelector() {
    const [isOpen, setIsOpen] = useState(false);
    const { theme, setTheme } = useCodeEditorStore();

    const handleThemeSelect = (selectedTheme: string) => {
        setTheme(selectedTheme);
        setIsOpen(false);
    };

    const currentTheme = THEMES.find(t => t.id === theme) || THEMES[0];

    return (
        <div className="relative">
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="flex items-center gap-2 px-3 py-2 bg-[#1e1e2e] rounded-lg ring-1 ring-white/5 hover:ring-white/10 transition-all"
            >
                <Palette className="w-4 h-4 text-gray-400" />
                <div 
                    className="w-4 h-4 rounded border border-white/10"
                    style={{ backgroundColor: currentTheme.color }}
                />
                <ChevronDown className="w-4 h-4 text-gray-400" />
            </button>

            {isOpen && (
                <div className="absolute top-full right-0 mt-2 bg-[#1e1e2e] rounded-lg ring-1 ring-white/10 shadow-xl z-50 min-w-[180px]">
                    <div className="py-2">
                        {THEMES.map((themeOption) => (
                            <button
                                key={themeOption.id}
                                onClick={() => handleThemeSelect(themeOption.id)}
                                className="flex items-center gap-3 w-full px-4 py-2 text-left hover:bg-white/5 transition-colors"
                            >
                                <div 
                                    className="w-4 h-4 rounded border border-white/10"
                                    style={{ backgroundColor: themeOption.color }}
                                />
                                <span className="text-sm font-medium text-gray-300">
                                    {themeOption.label}
                                </span>
                                {theme === themeOption.id && (
                                    <div className="ml-auto w-2 h-2 bg-blue-400 rounded-full"></div>
                                )}
                            </button>
                        ))}
                    </div>
                </div>
            )}

            {isOpen && (
                <div 
                    className="fixed inset-0 z-40" 
                    onClick={() => setIsOpen(false)}
                />
            )}
        </div>
    );
}

export default ThemeSelector;