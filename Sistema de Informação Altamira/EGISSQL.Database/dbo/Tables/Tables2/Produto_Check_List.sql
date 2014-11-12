CREATE TABLE [dbo].[Produto_Check_List] (
    [cd_produto_check_list]  INT           NOT NULL,
    [nm_produto_check_list]  VARCHAR (40)  NULL,
    [sg_produto_check_list]  CHAR (10)     NULL,
    [nm_img_produto_check]   VARCHAR (100) NULL,
    [nm_obs_produto_check]   VARCHAR (40)  NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ic_ativo_produto_check] CHAR (1)      NULL,
    CONSTRAINT [PK_Produto_Check_List] PRIMARY KEY CLUSTERED ([cd_produto_check_list] ASC) WITH (FILLFACTOR = 90)
);

