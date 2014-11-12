
/****** Object:  Stored Procedure dbo.SPVE_VISITAS_ALTERAR    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPVE_VISITAS_ALTERAR    Script Date: 25/08/1999 20:11:45 ******/
CREATE PROCEDURE SPVE_VISITAS_ALTERAR
	
	@Numero 		int,
	@Data  			smalldatetime,
	@Abreviado     		nvarchar(14),
	@Nome          		nvarchar(40),
	@Endereco      		nvarchar(40),
	@Bairro        		nvarchar(25),
	@Cidade        		nvarchar(25),
   	@Estado        		nvarchar(2),
	@CEP			varchar(9),
	@DDD           		nvarchar(4),
    	@Telefone      		nvarchar(25),
	@DDDFax		nvarchar(4),
	@NumeroFax		nvarchar(25),
	@Email			varchar(30),
    	@Contato         		varchar(25),
    	@Departamento  		nvarchar(20),
    	@Representante 		nvarchar(3),
    	@Propaganda 		smallint,
	@Produto		smallint,
	@Chamado		smallint,
	@Potencial		smallint,
	@Ratividade		smallint,
    	@Observacao    		text
AS

BEGIN

	UPDATE VE_Visitas
	   SET  	vevi_Data  		= @Data,
		vevi_Abreviado     		= @Abreviado,
		vevi_Nome          		= @Nome,
	       	vevi_Endereco      		= @Endereco,
	       	vevi_Bairro        		= @Bairro,
	       	vevi_Cidade        		= @Cidade,
	       	vevi_Estado        		= @Estado,
		vevi_CEP		= @CEP,
           		vevi_DDD           		= @DDD,
           		vevi_Telefone      		= @Telefone,
           		vevi_Contato       		= @Contato, 
           		vevi_Departamento  	= @Departamento,
           		vevi_Representante 	= @Representante,
           		vevi_Propaganda	 	= @Propaganda,
           		vevi_Produto	 	= @Produto,
           		vevi_Chamado	 	= @Chamado,
           		vevi_Observacao    	= @Observacao,
           		vevi_DDDFax	 	= @DDDFax,
           		vevi_NumeroFax	 	= @NumeroFax,
           		vevi_EMail	 	= @EMail,
		vevi_Potencial		= @Potencial,
		vevi_RAtividade		= @RAtividade
         WHERE vevi_Numero = @Numero
END








