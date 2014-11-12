CREATE TABLE [dbo].[Recepcao] (
    [cd_recepcao]        INT          NOT NULL,
    [nm_recepcao]        VARCHAR (40) NULL,
    [sg_recepcao]        CHAR (10)    NULL,
    [cd_departamento]    INT          NULL,
    [ic_acesso_recepcao] CHAR (1)     NULL,
    [ic_pardao_recepcao] CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Recepcao] PRIMARY KEY CLUSTERED ([cd_recepcao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Recepcao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

