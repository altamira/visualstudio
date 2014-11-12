
/****** Object:  Stored Procedure dbo.SPVE_VISITASNOVAS_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPVE_VISITAS_INCLUIR    Script Date: 25/08/1999 20:11:46 ******/
CREATE PROCEDURE SPVE_VISITASNOVAS_INCLUIR
	@Numero 		int,
	@Data  			smalldatetime,
	@Abreviado     		char(14),
	@Nome          		varchar(40),
	@Endereco      		varchar(40),
	@Bairro        		varchar(25),
	@Cidade        		varchar(25),
   	@Estado        		char(2),
	@CEP			char(9),
	@DDD           		char(4),
    	@Telefone      		char(25),
	@DDDFax		char(4),
	@NumeroFax		varchar(4),
	@Email			varchar(30),
    	@Contato         		char(25),
    	@Departamento  		varchar(20),
    	@Representante 		char(3),
    	@Propaganda 		smallint,
	@Produto		smallint,
	@Chamado		smallint,
	@Potencial		smallint,
	@Ratividade		smallint,
    	@Observacao    		text
   
AS

BEGIN

	INSERT INTO VE_VisitasNovas(vevi_Numero,
		vevi_Data,
		vevi_Abreviado,
		vevi_Nome,
	       	vevi_Endereco,
	       	vevi_Bairro,
	       	vevi_Cidade,
	       	vevi_Estado,
		vevi_CEP,
           		vevi_DDD,
           		vevi_Telefone,
           		vevi_Contato,
           		vevi_Departamento,
           		vevi_Representante,
           		vevi_Propaganda,
           		vevi_Produto,
           		vevi_Chamado,
           		vevi_Observacao,
           		vevi_DDDFax,
           		vevi_NumeroFax,
           		vevi_EMail,
		vevi_Potencial,
		vevi_RAtividade)
                          VALUES (@Numero,
		@Data,
		@Abreviado,
		@Nome,
	       	@Endereco,
	       	@Bairro,
	       	@Cidade,
	       	@Estado,
		@CEP,
           		@DDD,
           		@Telefone,
           		@Contato, 
           		@Departamento,
           		@Representante,
           		@Propaganda,
           		@Produto,
           		@Chamado,
           		@Observacao,
           		@DDDFax,
           		@NumeroFax,
           		@EMail,
		@Potencial,
		@RAtividade)
END







