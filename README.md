# Pessoas Politicamente Expostas
API para importar dados disponibilizados pelo [Portal da Transparencia](https://www.portaltransparencia.gov.br/download-de-dados/pep) e então disponibilizá-los para consulta em Endpoints http.

Apesar de ainda não estar completa, atualmente a API está funcional e em produção a partir no domínio https://pep.claudlabs.com
### Consultas
Consulta por CPF parcial [^1]
```http
GET /api/pep/:cpf_parcial
```
Exemplo:
```http
GET http://pep.claudlabs.com/api/pep/378239
```
Response:
```json
[
  {
    "cpf_parcial": "378239",
    "data_carencia": "31/12/2025",
    "data_fim": "31/12/2020",
    "data_inicio": "01/01/2017",
    "fonte": {
      "ano_mes": "202203",
      "data_de_insercao": "2022-05-09T20:44:16-03:00"
    },
    "nome": "ABEL HACK",
    "regiao": "MUN. DE RIO NEGRINHO-SC",
    "sigla": "VEREAD"
  }
]
```
**Sempre será retornado uma lista**, pois um político pode ocupar um ou mais cargos entre o período considerado como um PEP. A maioria dos casos é de 1:1.

Consulta por nome:
```HTTP
GET /pep/:nome
```
Não é necessário inserir o nome inteiro, mas deve fornecer ao menos 3 caracteres.

### Atualizar dados

Quando houver novas publicações no portal da transparência, basta fazer uma requisição para o endpont abaixo informando o ano_mes que deseja importar.
```http
POST /api/pep/sources/:ano_mes
```

Exemplo:
```http
POST https://pep.claudlabs.com/api/pep/sources/202205
```

O site da transparência fica offline com alguma frequência, então se não funcionar na primeira tentativa, tente novamente em alguns minutos.

Se der tudo certo, a aplicação iniciara a tarefa **async** e em poucos segundos os dados estarão disponíveis para consulta

E para consulta das fontes importadas:
```http
GET /api/pep/sources
```
--- 
[^1]: CPF parcial*: Os dados são disponibilizados nesse formato pelo Portal da Transparência

### Hospede a aplicação

### Projeto

- #### Features
	- ~~Download CSV~~
	- ~~Parser CSV~~
	- ~~Adicionar informações ao banco de dados~~
	- ~~Endpoint point para importação das informações~~
	- ~~Endpoint para consultas~~
	- ~~Docker~~
	- Genserver para atualização automática das fontes
	- Documentação para rodar o projeto localmente
	- Unit Tests
	- CI com Build distribuido e cache
	  - Com cache próprio será possível diminuir consideravelmente o tamanho da imagem, visto que é utilizado um elixir/erlang com wx e outros bloats, pois é o disponibilizado pelo cache do nixos/nixpkgs


- #### Opcional
	- ~~Melhorar a performance da importação ao banco de dados~~

### Licença

Esse código tem o principal objetivo a evolução técnica do autor, sem qualquer fim lucrativo, portanto, é proibido a utilização/distribuição que busque lucro diretamente.

Deve obedecer todas as leis e condutas eventualmente exigidas pela Controladoria Geral da União.

