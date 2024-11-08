package main

import (
        "context"
        "crypto/ecdsa"
        "fmt"
        "log"
        "math/big"

        "github.com/ethereum/go-ethereum/accounts/abi/bind"
        "github.com/ethereum/go-ethereum/crypto"
        "github.com/ethereum/go-ethereum/ethclient"

        store "go-eherrum/work/contracts/store" // for demo
)

func main() {
	client, err := ethclient.Dial("http://127.0.0.1:8545")
        if err != nil {
                log.Fatal(err)
        }

        privateKey, err := crypto.HexToECDSA("86f41f0ed978135a3016fdcfcc3f85b62983a3063c46f62c92d28a284b8b0b33")
        if err != nil {
                log.Fatal(err)
        }

        publicKey := privateKey.Public()
        publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
        if !ok {
                log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
        }

        fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
        nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
        if err != nil {
                log.Fatal(err)
        }

        gasPrice, err := client.SuggestGasPrice(context.Background())
        if err != nil {
                log.Fatal(err)
        }

        auth := bind.NewKeyedTransactor(privateKey)
        auth.Nonce = big.NewInt(int64(nonce))
        auth.Value = big.NewInt(0)     // in wei
        auth.GasLimit = uint64(300000) // in units
        auth.GasPrice = gasPrice

        input := "1.0"
        address, tx, instance, err := store.DeployStore(auth, client, input)
        if err != nil {
                log.Fatal(err)
        }

        fmt.Println(address.Hex())   // 0x147B8eb97fD247D06C4006D269c90C1908Fb5D54
        fmt.Println(tx.Hash().Hex()) // 0xdae8ba5444eefdc99f4d45cd0c4f24056cba6a02cefbf78066ef9f4188ff7dc0

        _ = instance
}