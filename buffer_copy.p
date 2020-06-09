DEF TEMP-TABLE tt-dados LIKE customer.

CREATE tt-dados.
UPDATE tt-dados WITH 2 COL.

CREATE customer.
BUFFER-COPY tt-dados TO customer.
