CREATE TABLE [dbo].[NFE_Finalidade] (
    [cd_finalidade_nfe] INT          NOT NULL,
    [nm_finalidade_nfe] VARCHAR (50) NULL,
    [sg_finalidade_nfe] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_NFE_Finalidade] PRIMARY KEY CLUSTERED ([cd_finalidade_nfe] ASC)
);

