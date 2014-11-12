CREATE TABLE [dbo].[Tipo_Emprestimo] (
    [cd_tipo_emprestimo] INT          NOT NULL,
    [nm_tipo_emprestimo] VARCHAR (30) NOT NULL,
    [sg_tipo_emprestimo] CHAR (10)    NULL,
    [pc_tipo_emprestimo] FLOAT (53)   NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL
);

