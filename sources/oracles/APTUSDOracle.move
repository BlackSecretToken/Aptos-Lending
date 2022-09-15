address Quantum {

module APTUSDOracle {
    use Quantum::Oracle::{DataRecord};
    use Quantum::PriceOracle::{Self};

    /// The APT to USD price oracle
    struct APTUSD has copy,store,drop {}

    public fun register(sender: &signer){
        PriceOracle::register_oracle<APTUSD>(sender, 6);
    }

    public fun read(ds_addr: address) : u128{
        PriceOracle::read<APTUSD>(ds_addr)
    }

    public fun read_record(ds_addr: address): DataRecord<u128>{
        PriceOracle::read_record<APTUSD>(ds_addr)
    }

    public fun read_records(ds_addrs: &vector<address>): vector<DataRecord<u128>>{
        PriceOracle::read_records<APTUSD>(ds_addrs)
    }
}
}