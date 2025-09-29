"use client";
import { useCodeEditorStore } from "../store/useCodeEditorStore";
import { LANGUAGE_CONFIG } from "../constants";
import { ChevronDown } from "lucide-react";
import { useState } from "react";

interface LanguageSelectorProps {
    hasAccess: boolean;
}

function LanguageSelector({ hasAccess }: LanguageSelectorProps) {
    const [isOpen, setIsOpen] = useState(false);
    const { language, setLanguage } = useCodeEditorStore();

    const languages = Object.values(LANGUAGE_CONFIG);

    const handleLanguageSelect = (selectedLanguage: string) => {
        setLanguage(selectedLanguage);
        setIsOpen(false);
    };

    // For basic auth, we'll allow all languages for now
    const getAvailableLanguages = () => {
        return languages;
    };

    return (
        <div className="relative">
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="flex items-center gap-3 px-3 py-2 bg-[#1e1e2e] rounded-lg ring-1 ring-white/5 hover:ring-white/10 transition-all"
            >
                <img 
                    src={LANGUAGE_CONFIG[language].logoPath} 
                    alt={LANGUAGE_CONFIG[language].label} 
                    className="w-5 h-5"
                />
                <span className="text-sm font-medium text-gray-300 min-w-[70px] text-left">
                    {LANGUAGE_CONFIG[language].label}
                </span>
                <ChevronDown className="w-4 h-4 text-gray-400" />
            </button>

            {isOpen && (
                <div className="absolute top-full left-0 mt-2 bg-[#1e1e2e] rounded-lg ring-1 ring-white/10 shadow-xl z-50 min-w-[200px]">
                    <div className="py-2">
                        {getAvailableLanguages().map((lang) => (
                            <button
                                key={lang.id}
                                onClick={() => handleLanguageSelect(lang.id)}
                                className="flex items-center gap-3 w-full px-4 py-2 text-left hover:bg-white/5 transition-colors"
                            >
                                <img 
                                    src={lang.logoPath} 
                                    alt={lang.label} 
                                    className="w-5 h-5"
                                />
                                <span className="text-sm font-medium text-gray-300">
                                    {lang.label}
                                </span>
                                {language === lang.id && (
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

export default LanguageSelector;