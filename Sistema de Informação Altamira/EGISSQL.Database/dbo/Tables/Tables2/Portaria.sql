CREATE TABLE [dbo].[Portaria] (
    [cd_portaria]        INT          NOT NULL,
    [nm_portaria]        VARCHAR (40) NULL,
    [sg_portaria]        CHAR (10)    NULL,
    [cd_departamento]    INT          NULL,
    [ic_acesso_portaria] CHAR (1)     NULL,
    [ic_padaro_portaria] CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Portaria] PRIMARY KEY CLUSTERED ([cd_portaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Portaria_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

