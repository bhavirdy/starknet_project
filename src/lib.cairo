#[starknet::interface]
trait IP2PVehicleSharing<T> {
    // Register a Vehicle
    fn register_vehicle(ref self: T);
}

#[starknet::contract]
mod P2PVehicleSharing {
    use starknet::storage::StoragePathEntry;
use core::starknet::ContractAddress;
    use core::starknet::get_caller_address;
    use core::starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StorageMapReadAccess,
        StorageMapWriteAccess, Map,
    };

    // Storage
    #[derive(starknet::Store)]
    struct Vehicle {
        vehicleId: u256,
        vehicleOwner: ContractAddress,
        vehicleDescription: felt252,
        vehicleDailyRate: u256,
        vehicleIsAvailable: bool,
    }
    
    #[derive(starknet::Store)]
    struct Booking {
        vehicleId: u256,
        vehicleRenter: ContractAddress,
        startDate: u256,
        endDate: u256,
        totalCost: u256,
        isCompleted: bool,
    }

    #[storage]
    struct Storage {
        nextVehicleId: u256,
        nextBookingId: u256,
    
        vehicles: Map<u256, Vehicle>,
        bookings: Map<u256, Booking>,
    }

    // Events
    #[event]
    #[derive(Drop, Clone, starknet::Event)]
    pub enum Event {
        VehicleRegistered: VehicleRegistered,
        VehicleBooked: VehicleBooked,
        BookingCompleted: BookingCompleted,
    }
    #[derive(Drop, Clone, starknet::Event)]
    pub struct VehicleRegistered {
        vehicleId: u256,
        vehicleOwner: ContractAddress,
        vehicleDescription: felt252,
        vehicleDailyRate: u256,
    }
    #[derive(Drop, Clone, starknet::Event)]
    pub struct VehicleBooked {
        bookingId: u256,
        vehicleId: u256,
        vehicleRenter: ContractAddress,
        startDate: u256,
        endDate: u256,
        totalCost: u256,
    }
    #[derive(Drop, Clone, starknet::Event)]
    pub struct BookingCompleted {
        bookingId: u256,
    }

    // Functions
    #[abi(embed_v0)]
    impl P2PVehicleSharing of super::IP2PVehicleSharing<ContractState> {

        // Register a Vehicle
        fn register_vehicle(ref self: ContractState) {
            
            //to do: require daily rate to be more than 0

            let nextVehicleId = self.nextVehicleId.read();
            let owner = get_caller_address();

            let vehicle = self.vehicles.entry(nextVehicleId.clone());
            vehicle.vehicleId.write(nextVehicleId);
            vehicle.vehicleOwner.write(owner);
            vehicle.vehicleDescription.write('0x636f6f6c76656869636c65');
            vehicle.vehicleDailyRate.write(200);
            vehicle.vehicleIsAvailable.write(true);

            self.emit(VehicleRegistered {
                vehicleId: self.nextVehicleId.read(),
                vehicleOwner: get_caller_address(),
                vehicleDescription: '0x636f6f6c76656869636c65',
                vehicleDailyRate: 200,
            });
            self.nextVehicleId.write(nextVehicleId + 1);
        }

        // Book a Vehicle

        // Complete a Booking

        // Retrieve Vehicle Details

        // Retrieve Booking Details

    }
}