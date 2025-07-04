
export const ROLE = {
  SUPER_ADMIN: 'super_admin',
  PRODUCT_MANAGER: 'product_manager',
  ORDER_MANAGER: 'order_manager',
  MARKETING_MANAGER: 'marketing_manager',
}

export const permissions = {
  [ROLE.SUPER_ADMIN]: [
    'manage_users',
    'site_settings',
    'manage_products',
    'manage_categories',
    'update_inventory',
    'view_orders',
    'process_orders',
    'handle_returns',
    'access_customer_data',
    'manage_support',
    'create_discounts',
    'manage_homepage',
    'manage_content',
    'view_analytics',
  ],
  [ROLE.PRODUCT_MANAGER]: [
    'manage_products',
    'manage_categories',
    'update_inventory',
    'view_orders',
    'view_analytics',
  ],
  [ROLE.ORDER_MANAGER]: [
    'view_orders',
    'process_orders',
    'handle_returns',
    'access_customer_data',
    'manage_support',
    'view_analytics',
  ],
  [ROLE.MARKETING_MANAGER]: [
    'view_orders',
    'create_discounts',
    'manage_homepage',
    'manage_content',
    'view_analytics',
  ],
}

export function hasPermission(role, permission) {
  return permissions[role]?.includes(permission)
}