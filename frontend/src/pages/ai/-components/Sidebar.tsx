import { Link, useLocation, useNavigate } from "@tanstack/react-router";
import { MessageSquare, Folder, Settings, Sparkles, WorkflowIcon } from "lucide-react";
import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarGroup,
    SidebarGroupContent,
    SidebarGroupLabel,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    useSidebar,
} from "@/components/ui/sidebar";
import { cn } from "@/lib/utils";

const menuItems = [
    {
        title: "投标助手",
        url: "/ai/executions",
        icon: MessageSquare,
    },
    {
        title: "文件管理",
        url: "/ai/file-manager",
        icon: Folder,
    },
    {
        title: "工作流管理",
        url: "/ai/workflows",
        icon: WorkflowIcon,
    },
];

const settingsItem = {
    title: "系统设置",
    url: "/ai/settings",
    icon: Settings,
};

function AiSidebar() {
    const location = useLocation();
    const navigate = useNavigate();
    const { state, setOpenMobile } = useSidebar();
    const collapsed = state === "collapsed";

    const goToHome = () => {
        navigate({ to: "/" });
    };

    const handleNavClick = () => {
        setOpenMobile(false);
    };

    return (
        <Sidebar collapsible="icon">
            <SidebarHeader className="border-b border-sidebar-border p-1">
                <div className="flex items-center gap-3 px-2 h-14">
                    <button
                        title="返回首页"
                        onClick={goToHome}
                        className="flex items-center justify-center w-8 h-8 rounded-lg bg-primary shrink-0 hover:opacity-90 transition-opacity"
                    >
                        <Sparkles className="w-5 h-5 text-primary-foreground" />
                    </button>
                    <span
                        className={cn(
                            "font-semibold text-sidebar-foreground text-lg whitespace-nowrap overflow-hidden transition-opacity",
                            collapsed && "opacity-0 w-0"
                        )}
                    >
                        AI 工作台
                    </span>
                </div>
            </SidebarHeader>

            <SidebarContent>
                <SidebarGroup>
                    <SidebarGroupLabel
                        className={cn(
                            "text-xs font-semibold text-muted-foreground uppercase tracking-wider",
                            collapsed && "sr-only"
                        )}
                    >
                        导航
                    </SidebarGroupLabel>
                    <SidebarGroupContent>
                        <SidebarMenu>
                            {menuItems.map((item) => {
                                const Icon = item.icon;
                                const isActive =
                                    location.pathname === item.url ||
                                    location.pathname.startsWith(item.url + "/");
                                return (
                                    <SidebarMenuItem key={item.url}>
                                        <SidebarMenuButton
                                            className="[&>svg]:size-5"
                                            asChild
                                            isActive={isActive}
                                            tooltip={item.title}
                                        >
                                            <Link
                                                className="px-3 py-5"
                                                to={item.url}
                                                onClick={handleNavClick}>
                                                <Icon/>
                                                <span>{item.title}</span>
                                            </Link>
                                        </SidebarMenuButton>
                                    </SidebarMenuItem>
                                );
                            })}
                        </SidebarMenu>
                    </SidebarGroupContent>
                </SidebarGroup>
            </SidebarContent>

            <SidebarFooter className="border-t border-sidebar-border">
                <SidebarMenu>
                    <SidebarMenuItem>
                        <SidebarMenuButton
                            asChild
                            isActive={
                                location.pathname === settingsItem.url ||
                                location.pathname.startsWith(settingsItem.url + "/")
                            }
                            tooltip={settingsItem.title}
                        >
                            <Link to={settingsItem.url} onClick={handleNavClick}>
                                <Settings className="w-5 h-5 shrink-0" />
                                <span>{settingsItem.title}</span>
                            </Link>
                        </SidebarMenuButton>
                    </SidebarMenuItem>
                </SidebarMenu>
                <div
                    className={cn(
                        "px-3 py-2 text-xs text-muted-foreground whitespace-nowrap",
                        collapsed && "hidden"
                    )}
                >
                    版本 1.0.0
                </div>
            </SidebarFooter>
        </Sidebar>
    );
}

export default AiSidebar;
