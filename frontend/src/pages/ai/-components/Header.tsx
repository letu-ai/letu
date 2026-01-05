import { Link } from "@tanstack/react-router";
import {
  Settings,
  User,
  LogOut,
  Menu,
  PanelLeftClose,
  PanelLeft,
  ChevronDown,
} from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { useAppConfig } from "@/components/AppConfigProvider";
import { useSidebar } from "@/components/ui/sidebar";
import { getApiBaseUrl } from "@/utils/urlUtils";

export function Navbar() {
  const { currentUser: user, userExtraInfo } = useAppConfig();
  const { state, toggleSidebar, setOpenMobile } = useSidebar();
  const collapsed = state === "collapsed";

  return (
    <header className="flex items-center justify-between h-14 sm:h-16 px-4 sm:px-6 border-b border-border bg-background">
      {/* 左侧：折叠按钮 + 移动端菜单 */}
      <div className="flex items-center gap-2">
        {/* 桌面端折叠按钮 */}
        <Button
          variant="ghost"
          size="icon"
          className="hidden md:flex h-9 w-9"
          onClick={toggleSidebar}
        >
          {collapsed ? (
            <PanelLeft className="w-5 h-5" />
          ) : (
            <PanelLeftClose className="w-5 h-5" />
          )}
        </Button>

        {/* 移动端汉堡菜单 */}
        <Button
          variant="ghost"
          size="icon"
          className="md:hidden h-9 w-9"
          onClick={() => setOpenMobile(true)}
        >
          <Menu className="w-5 h-5" />
        </Button>
      </div>

      {/* 右侧：用户信息 */}
      <DropdownMenu>
        <DropdownMenuTrigger className="flex items-center gap-2 px-2 py-1.5 rounded-lg hover:bg-secondary transition-colors outline-none">
          <Avatar className="w-8 h-8">
            <AvatarImage src={`${getApiBaseUrl()}/api/my/profile/avatar`} />
            <AvatarFallback className="bg-primary/10 text-primary text-sm">
              <img
                src="/images/avatar/male.png"
                alt="Avatar"
                className="size-full"
              />
            </AvatarFallback>
          </Avatar>
          <span className="text-sm font-medium text-foreground hidden sm:block">
            {user.name}
          </span>
          <ChevronDown className="w-4 h-4 text-muted-foreground hidden sm:block" />
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-80 p-0">
          <div className="bg-muted rounded-t-lg border-b border-border">
            <div className="p-6">
              <div className="flex items-start gap-4 mb-4">
                <Avatar className="size-12 ring-2 ring-border ring-offset-2 ring-offset-background">
                  <AvatarImage
                    src={`${getApiBaseUrl()}/api/my/profile/avatar`}
                  />
                  <AvatarFallback className="bg-muted text-muted-foreground">
                    <img
                      src="/images/avatar/male.png"
                      alt="Avatar"
                      className="size-full"
                    />
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1 space-y-2">
                  <div>
                    <div className="text-base font-semibold text-foreground leading-none">
                      {user.name}
                    </div>
                    <div className="text-sm text-muted-foreground mt-1">
                      {user.email}
                    </div>
                  </div>
                  <div className="space-y-1.5 pt-1">
                    <div className="flex items-center gap-2 text-muted-foreground">
                      <span className="text-base">👥</span>
                      <span className="text-sm">
                        {userExtraInfo.departmentName}
                      </span>
                    </div>
                    <div className="flex items-center gap-2 text-muted-foreground">
                      <span className="text-base">🏢</span>
                      <span className="text-sm">
                        {userExtraInfo.organizationUnitName}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="bg-background rounded-b-lg">
            <DropdownMenuItem asChild>
              <a
                href="/admin/users"
                className="flex items-center gap-2 cursor-pointer"
              >
                <Settings className="size-4" />
                <span>系统设置</span>
              </a>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <a
                href="/my/profile"
                className="flex items-center gap-2 cursor-pointer"
              >
                <User className="size-4" />
                <span>我的账户</span>
              </a>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild variant="destructive">
              <Link
                to="/account/logout"
                className="flex items-center gap-2 cursor-pointer"
              >
                <LogOut className="size-4" />
                <span>注销</span>
              </Link>
            </DropdownMenuItem>
          </div>
        </DropdownMenuContent>
      </DropdownMenu>
    </header>
  );
}
