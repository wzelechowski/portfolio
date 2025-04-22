// migrations/20231201000001_create_shop_tables.js
/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function (knex) {
    return knex.schema
      // Tabela 'categories'
      .createTable('categories', function (table) {
        table.increments('id').primary(); // Klucz główny
        table.string('name').notNullable().unique(); // Kolumna nazwy kategorii
      })
      // Tabela 'order_statuses'
      .then(() => {
        return knex.schema.createTable('order_statuses', function (table) {
          table.increments('id').primary(); // Klucz główny
          table.string('name').notNullable().unique(); // Nazwa statusu zamówienia
        });
      })
      // Tabela 'products'
      .then(() => {
        return knex.schema.createTable('products', function (table) {
          table.increments('id').primary(); // Klucz główny
          table.string('name').notNullable(); // Kolumna nazwy produktu
          table.text('description'); // Kolumna opisu (może zawierać HTML)
          table.decimal('unit_price', 10, 2).notNullable(); // Cena jednostkowa
          table.decimal('unit_weight', 10, 2).notNullable(); // Waga jednostkowa
          table
            .integer('category_id')
            .unsigned()
            .references('id')
            .inTable('categories')
            .notNullable(); // Obowiązkowe odniesienie do kategorii
        });
      })
      // Tabela 'orders'
      .then(() => {
        return knex.schema.createTable('orders', function (table) {
          table.increments('id').primary(); // Klucz główny
          table.date('confirmation_date'); // Data zatwierdzenia zamówienia (może być null)
          table
            .integer('status_id')
            .unsigned()
            .references('id')
            .inTable('order_statuses')
            .notNullable(); // Odniesienie do statusu zamówienia
          table.string('username').notNullable(); // Nazwa użytkownika
          table.string('email').notNullable(); // Email
          table.string('phone_number').notNullable(); // Numer telefonu
        });
      })
      // Tabela 'order_items'
      .then(() => {
        return knex.schema.createTable('order_items', function (table) {
          table.increments('id').primary(); // Klucz główny
          table
            .integer('order_id')
            .unsigned()
            .references('id')
            .inTable('orders')
            .onDelete('CASCADE'); // Odniesienie do zamówienia
          table
            .integer('product_id')
            .unsigned()
            .references('id')
            .inTable('products')
            .onDelete('CASCADE'); // Odniesienie do produktu
          table.integer('quantity').unsigned().notNullable(); // Ilość sztuk produktu
          table.decimal('price', 10, 2).notNullable(); // Cena produktu w momencie zamówienia
          table.decimal('discount', 10, 2).defaultTo(0); // Zniżka na produkt
        });
      })
      .then(() => {
        // Dodanie predefiniowanych statusów
        return knex('order_statuses').insert([
          { name: 'NOT_CONFIRMED' },
          { name: 'CONFIRMED' },
          { name: 'CANCELLED' },
          { name: 'COMPLETED' },
        ]);
      })
      .then(() => {
        // Dodanie przykładowych kategorii
        return knex('categories').insert([
          { name: 'Electronics' },
          { name: 'Clothing' },
          { name: 'Books' },
        ]);
      });
  };
  
  /**
   * @param { import("knex").Knex } knex
   * @returns { Promise<void> }
   */
  exports.down = function (knex) {
    return knex.schema
      .dropTableIfExists('order_items')
      .dropTableIfExists('orders')
      .dropTableIfExists('products')
      .dropTableIfExists('order_statuses')
      .dropTableIfExists('categories');
  };
  