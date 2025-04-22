exports.up = function(knex) {
    return knex.schema.createTable('opinions', function(table) {
        table.increments('id').primary(); // Unikalny identyfikator opinii
        table.integer('order_id').unsigned().notNullable(); // ID zamówienia
        table.string('username').notNullable(); // Username użytkownika
        table.integer('rating').notNullable().checkBetween([1, 5]); // Ocena (1-5)
        table.text('content').notNullable(); // Treść opinii

        // Klucze obce
        table.foreign('order_id').references('id').inTable('orders').onDelete('CASCADE');
    });
};

exports.down = function(knex) {
    return knex.schema.dropTableIfExists('opinions');
};
