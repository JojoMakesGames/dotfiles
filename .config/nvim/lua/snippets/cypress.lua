local ls = require 'luasnip'

return {
  ls.snippet('desc', {
    ls.text_node "describe('",
    ls.insert_node(1, 'description'),
    ls.text_node { "', () => {", '  ' },
    ls.insert_node(0),
    ls.text_node { '', '})' },
  }),

  ls.snippet('it', {
    ls.text_node "it('",
    ls.insert_node(1, 'should'),
    ls.text_node { "', () => {", '  ' },
    ls.insert_node(0),
    ls.text_node { '', '})' },
  }),

  ls.snippet('before', {
    ls.text_node { 'beforeEach(() => {', '  ' },
    ls.insert_node(0),
    ls.text_node { '', '})' },
  }),

  ls.snippet('get', {
    ls.text_node "cy.get('",
    ls.insert_node(1, 'selector'),
    ls.text_node "')",
    ls.insert_node(0),
  }),

  ls.snippet('cd', {
    ls.text_node 'cy.get(\'[data-testid="',
    ls.insert_node(1, 'name'),
    ls.text_node '"]\')',
    ls.insert_node(0),
  }),
}
