// migrations/20241212230302_create_users_table.js

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function (knex) {
    return knex.schema.createTable('users', function (table) {
      table.increments('id').primary(); // Klucz główny
      table.string('username').notNullable().unique(); // Nazwa użytkownika
      table.string('password').notNullable(); // Hasło
      table.enu('role', ['CUSTOMER', 'EMPLOYEE']).defaultTo('CUSTOMER'); // Rola użytkownika (domyślnie KLIENT)
    });
  };
  
  /**
   * @param { import("knex").Knex } knex
   * @returns { Promise<void> }
   */
  exports.down = function (knex) {
    return knex.schema.dropTableIfExists('users'); // Usuwanie tabeli 'users'
  };
  