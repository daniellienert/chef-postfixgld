Postfix GLD Cookbook
===================
Installs and configures the postfix grey listing daemon (GLD).

Requirements
------------
#### packages

- `chef/rewind`
- `mysql`
- `database`



Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>

  <tr>
    <td><tt>['postfixgld']['mysql']['user']</tt></td>
    <td>String</td>
    <td>Database user to add</td>
    <td><tt>gld</tt></td>
  </tr>

  <tr>
      <td><tt>['postfixgld']['mysql']['password']</tt></td>
      <td>String</td>
      <td>Database users password</td>
      <td><tt>gld</tt></td>
    </tr>

     <tr>
      <td><tt>['postfixgld']['mysql']['host']</tt></td>
      <td>String</td>
      <td>Database host</td>
      <td><tt>localhost</tt></td>
    </tr>


     <tr>
      <td><tt>['postfixgld']['mysql']['db']</tt></td>
      <td>String</td>
      <td>Database name</td>
      <td><tt>gld</tt></td>
    </tr>

     <tr>
      <td><tt>['postfixgld']['mxgrey']</tt></td>
      <td>Integer</td>
      <td>Set >0 to use the mxgrey algorithm</td>
      <td><tt>0</tt></td>
    </tr>
</table>

Usage
-----

include_recipe "postfixgld"


Contributing
------------

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Daniel Lienert
